'use client';

import { useEffect, useRef, useCallback } from 'react';

// Declare YouTube IFrame API types
declare global {
  interface Window {
    YT: {
      Player: new (
        elementId: string,
        options: {
          videoId: string;
          width?: number | string;
          height?: number | string;
          playerVars?: Record<string, number | string>;
          events?: {
            onReady?: (event: { target: YTPlayer }) => void;
            onStateChange?: (event: { data: number; target: YTPlayer }) => void;
          };
        }
      ) => YTPlayer;
      PlayerState: {
        ENDED: number;
        PLAYING: number;
        PAUSED: number;
        BUFFERING: number;
        CUED: number;
      };
    };
    onYouTubeIframeAPIReady?: () => void;
  }
}

interface YTPlayer {
  playVideo: () => void;
  pauseVideo: () => void;
  seekTo: (seconds: number, allowSeekAhead?: boolean) => void;
  destroy: () => void;
  getPlayerState: () => number;
  setPlaybackQuality: (quality: string) => void;
}

interface CachedPlayer {
  player: YTPlayer;
  videoId: string;
  ready: boolean;
}

interface YouTubePlayerProps {
  videoIds: string[];
  activeVideoId: string;
  activeIndex: number;
  isStarted: boolean;
  onPause: () => void;
  onEnd: () => void;
  onFirstPlay: () => void;
  onVideoPreloaded: (videoId: string) => void;
}

// Queue size - keep fewer videos to avoid browser throttling
// Too many concurrent videos causes buffering issues
const VIDEOS_AHEAD = 4;
const VIDEOS_BEHIND = 1;

export default function YouTubePlayer({ 
  videoIds,
  activeVideoId, 
  activeIndex,
  isStarted,
  onPause, 
  onEnd,
  onFirstPlay,
  onVideoPreloaded,
}: YouTubePlayerProps) {
  const cacheRef = useRef<Map<string, CachedPlayer>>(new Map());
  const containerRef = useRef<HTMLDivElement>(null);
  const apiReadyRef = useRef(false);
  const activeVideoIdRef = useRef(activeVideoId);
  const isStartedRef = useRef(isStarted);
  const initializedRef = useRef(false);

  // Keep refs in sync
  useEffect(() => {
    activeVideoIdRef.current = activeVideoId;
  }, [activeVideoId]);

  useEffect(() => {
    isStartedRef.current = isStarted;
  }, [isStarted]);

  // Load YouTube IFrame API
  useEffect(() => {
    if (window.YT && window.YT.Player) {
      apiReadyRef.current = true;
      return;
    }

    const existingCallback = window.onYouTubeIframeAPIReady;
    window.onYouTubeIframeAPIReady = () => {
      apiReadyRef.current = true;
      existingCallback?.();
    };

    if (!document.querySelector('script[src*="youtube.com/iframe_api"]')) {
      const tag = document.createElement('script');
      tag.src = 'https://www.youtube.com/iframe_api';
      const firstScriptTag = document.getElementsByTagName('script')[0];
      firstScriptTag.parentNode?.insertBefore(tag, firstScriptTag);
    }
  }, []);

  // Retry playing any videos stuck in buffering/cued state
  const retryStuckVideos = useCallback(() => {
    cacheRef.current.forEach((cached, id) => {
      if (cached.ready && id !== activeVideoIdRef.current) {
        try {
          const state = cached.player.getPlayerState();
          // State 3 = buffering, State 5 = cued - these need a retry
          if (state === 3 || state === 5) {
            console.log(`[YT] Retrying stuck video: ${id} (state ${state})`);
            cached.player.playVideo();
          }
        } catch (e) {
          // ignore
        }
      }
    });
  }, []);

  // Destroy a single player and remove from DOM
  const destroyPlayer = useCallback((videoId: string) => {
    const cached = cacheRef.current.get(videoId);
    if (cached) {
      console.log(`[YT] Destroying: ${videoId}`);
      try {
        cached.player.destroy();
      } catch (e) {
        console.warn('Failed to destroy player:', e);
      }
      document.getElementById(`yt-${videoId}`)?.remove();
      cacheRef.current.delete(videoId);
      
      // After destroying, retry any stuck videos (frees up a playback slot)
      setTimeout(retryStuckVideos, 100);
    }
  }, [retryStuckVideos]);

  // Create a player - always autoplay (they're hidden anyway)
  const createPlayer = useCallback((videoId: string, isActiveVideo: boolean): Promise<void> => {
    return new Promise((resolve) => {
      if (!apiReadyRef.current || !window.YT || !containerRef.current) {
        setTimeout(() => createPlayer(videoId, isActiveVideo).then(resolve), 100);
        return;
      }

      if (cacheRef.current.has(videoId)) {
        resolve();
        return;
      }

      console.log(`[YT] Creating: ${videoId} (active: ${isActiveVideo})`);

      const playerDiv = document.createElement('div');
      playerDiv.id = `yt-${videoId}`;
      playerDiv.className = isActiveVideo ? 'youtube-player-item' : 'youtube-player-item hidden';
      containerRef.current.appendChild(playerDiv);

      const cachedPlayer: CachedPlayer = {
        player: null as unknown as YTPlayer,
        videoId,
        ready: false,
      };
      cacheRef.current.set(videoId, cachedPlayer);

      const player = new window.YT.Player(`yt-${videoId}`, {
        videoId: videoId,
        width: '100%',
        height: '100%',
        playerVars: {
          autoplay: 1, // Always autoplay - videos are hidden until active
          mute: 1, // Mute to allow autoplay and reduce resource usage
          controls: 0,
          showinfo: 0,
          rel: 0,
          modestbranding: 1,
        },
        events: {
          onReady: (event) => {
            console.log(`[YT] Ready: ${videoId}`);
            cachedPlayer.player = player;
            cachedPlayer.ready = true;
            onVideoPreloaded(videoId);
            
            try {
              event.target.setPlaybackQuality('hd720');
            } catch (e) {
              // ignore
            }
            
            // Force play to start buffering (even if hidden)
            if (!isActiveVideo) {
              try {
                console.log(`[YT] Force playing for buffer: ${videoId}`);
                event.target.playVideo();
              } catch (e) {
                // ignore
              }
            }
            
            resolve();
          },
          onStateChange: (event) => {
            const isActive = videoId === activeVideoIdRef.current;
            
            if (isActive) {
              // Active video events
              if (event.data === 1) { // Playing
                console.log(`[YT] Playing: ${videoId}`);
                if (!isStartedRef.current) {
                  onFirstPlay();
                }
              } else if (event.data === 0) { // Ended
                console.log(`[YT] Ended: ${videoId}`);
                onEnd();
              } else if (event.data === 2) { // Paused
                console.log(`[YT] Paused: ${videoId}`);
                if (isStartedRef.current) {
                  onPause();
                }
              }
            } else {
              // Background video state changes
              if (event.data === 1) {
                console.log(`[YT] Buffering (playing in bg): ${videoId}`);
              } else if (event.data === 3) {
                console.log(`[YT] Buffering (loading): ${videoId}`);
              }
            }
          },
        },
      });

      cachedPlayer.player = player;
    });
  }, [onPause, onEnd, onFirstPlay, onVideoPreloaded]);

  // Get video IDs that should be in the queue
  const getQueueIds = useCallback((currentIndex: number): string[] => {
    const ids: string[] = [];
    
    // Current video first
    ids.push(videoIds[currentIndex]);
    
    // Next N videos
    for (let i = 1; i <= VIDEOS_AHEAD; i++) {
      const idx = (currentIndex + i) % videoIds.length;
      ids.push(videoIds[idx]);
    }
    
    // Previous video (keep briefly to avoid flash on quick back-navigation)
    const prevIdx = (currentIndex - 1 + videoIds.length) % videoIds.length;
    ids.push(videoIds[prevIdx]);
    
    return ids;
  }, [videoIds]);

  // Sync the player queue with what should exist
  const syncQueue = useCallback((currentIndex: number) => {
    const queueIds = getQueueIds(currentIndex);
    const queueSet = new Set(queueIds);
    
    // Remove players not in queue
    const toRemove: string[] = [];
    cacheRef.current.forEach((_, id) => {
      if (!queueSet.has(id)) {
        toRemove.push(id);
      }
    });
    toRemove.forEach(id => destroyPlayer(id));
    
    // Create players that are missing
    // No stagger on initial load so all start buffering immediately
    // Small stagger (100ms) when adding single videos to avoid hammering YouTube
    const missingIds = queueIds.filter((id) => !cacheRef.current.has(id));
    const shouldStagger = missingIds.length === 1;
    
    let delay = 0;
    missingIds.forEach((id) => {
      const isActive = id === queueIds[0];
      if (shouldStagger) {
        setTimeout(() => {
          if (!cacheRef.current.has(id)) {
            createPlayer(id, isActive);
          }
        }, 100);
      } else {
        createPlayer(id, isActive);
      }
    });
  }, [getQueueIds, destroyPlayer, createPlayer]);

  // Initialize on mount
  useEffect(() => {
    if (videoIds.length > 0 && activeVideoId && !initializedRef.current) {
      initializedRef.current = true;
      
      const init = () => {
        if (!apiReadyRef.current) {
          setTimeout(init, 100);
          return;
        }
        console.log(`[YT] Initializing with: ${activeVideoId}`);
        syncQueue(activeIndex);
      };
      init();
    }
  }, [videoIds.length, activeVideoId, activeIndex, syncQueue]);

  // Periodic retry for stuck videos (every 500ms)
  useEffect(() => {
    if (!isStarted) return;
    
    const interval = setInterval(() => {
      retryStuckVideos();
    }, 500);
    
    return () => clearInterval(interval);
  }, [isStarted, retryStuckVideos]);

  // Handle video transitions
  useEffect(() => {
    if (!activeVideoId || !initializedRef.current) return;

    console.log(`[YT] Switching to: ${activeVideoId} (index ${activeIndex})`);

    // Hide all, show active
    cacheRef.current.forEach((_, id) => {
      const el = document.getElementById(`yt-${id}`);
      if (el) {
        if (id === activeVideoId) {
          el.classList.remove('hidden');
        } else {
          el.classList.add('hidden');
        }
      }
    });

    // Seek active video to start and play
    const activeCached = cacheRef.current.get(activeVideoId);
    if (activeCached && activeCached.ready && isStarted) {
      console.log(`[YT] Seeking to 0 and playing: ${activeVideoId}`);
      try {
        activeCached.player.seekTo(0, true);
        activeCached.player.playVideo();
      } catch (e) {
        console.warn('Error seeking/playing:', e);
      }
    }

    // Sync the queue (adds new video to end, removes old one)
    syncQueue(activeIndex);
    
  }, [activeVideoId, activeIndex, isStarted, syncQueue]);

  // Cleanup on unmount
  useEffect(() => {
    return () => {
      console.log('[YT] Unmounting, destroying all players');
      cacheRef.current.forEach((cached) => {
        try {
          cached.player?.destroy();
        } catch (e) {
          // ignore
        }
      });
      cacheRef.current.clear();
    };
  }, []);

  return (
    <div className="youtube-player-container" ref={containerRef}>
      {/* Players are dynamically added here */}
    </div>
  );
}

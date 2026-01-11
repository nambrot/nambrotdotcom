'use client';

import { useState, useEffect, useRef, useCallback, useMemo } from 'react';
import dynamic from 'next/dynamic';
import Link from 'next/link';
import { videoLocations, shuffleArray, VideoLocation } from '@/data/videos';
import Playlist from '@/components/aroundtheworld/Playlist';
import YouTubePlayer from '@/components/aroundtheworld/YouTubePlayer';

// Dynamic import for MapComponent to avoid SSR issues with Leaflet
const MapComponent = dynamic(
  () => import('@/components/aroundtheworld/MapComponent'),
  { ssr: false }
);

const ADVANCEMENT_TIME_NORMAL = 3000; // 3 seconds for preloaded videos
const ADVANCEMENT_TIME_LOADING = 10000; // 10 seconds for non-preloaded videos

export default function AroundTheWorldPage() {
  const [videos, setVideos] = useState<VideoLocation[]>([]);
  const [activeIndex, setActiveIndex] = useState(0);
  const [isStarted, setIsStarted] = useState(false); // User has clicked play on first video
  const [isZoomedIn, setIsZoomedIn] = useState(false);
  const audioRef = useRef<HTMLAudioElement>(null);
  const timerRef = useRef<NodeJS.Timeout | null>(null);
  const activeIndexRef = useRef(activeIndex);
  const preloadedIdsRef = useRef<Set<string>>(new Set());

  // Keep ref in sync with state for use in callbacks
  useEffect(() => {
    activeIndexRef.current = activeIndex;
  }, [activeIndex]);

  useEffect(() => {
    // Shuffle videos on mount
    setVideos(shuffleArray(videoLocations));
  }, []);

  useEffect(() => {
    // Cleanup timer on unmount
    return () => {
      if (timerRef.current) {
        clearTimeout(timerRef.current);
      }
    };
  }, []);

  // Memoize video IDs array for YouTubePlayer
  const videoIds = useMemo(() => videos.map(v => v.id), [videos]);

  const startAdvancementTimer = useCallback((duration: number) => {
    // Clear any existing timer
    if (timerRef.current) {
      clearTimeout(timerRef.current);
    }
    
    timerRef.current = setTimeout(() => {
      // Advance to next video
      if (videos.length === 0) return;
      
      const nextIndex = (activeIndexRef.current + 1) % videos.length;
      const nextVideoId = videos[nextIndex]?.id;
      const isPreloaded = preloadedIdsRef.current.has(nextVideoId);
      
      setActiveIndex(nextIndex);
      setIsZoomedIn(false);

      // Use longer time if next video isn't preloaded
      const nextDuration = isPreloaded ? ADVANCEMENT_TIME_NORMAL : ADVANCEMENT_TIME_LOADING;
      startAdvancementTimer(nextDuration);
    }, duration);
  }, [videos]);

  const playVideo = useCallback((index: number) => {
    // Clear any existing timer
    if (timerRef.current) {
      clearTimeout(timerRef.current);
    }

    const videoId = videos[index]?.id;
    const isPreloaded = preloadedIdsRef.current.has(videoId);

    setActiveIndex(index);
    setIsStarted(true);
    setIsZoomedIn(false);
    
    // Play background music
    if (audioRef.current) {
      audioRef.current.play().catch(() => {
        // Auto-play might be blocked, that's ok
      });
    }

    // Use longer time if video isn't preloaded yet
    const duration = isPreloaded ? ADVANCEMENT_TIME_NORMAL : ADVANCEMENT_TIME_LOADING;
    startAdvancementTimer(duration);
  }, [videos, startAdvancementTimer]);

  const pauseVideo = useCallback(() => {
    // Clear timer
    if (timerRef.current) {
      clearTimeout(timerRef.current);
      timerRef.current = null;
    }

    setIsZoomedIn(true);
    
    // Pause background music
    if (audioRef.current) {
      audioRef.current.pause();
    }
  }, []);

  const resumeVideo = useCallback(() => {
    setIsZoomedIn(false);
    
    // Resume background music
    if (audioRef.current) {
      audioRef.current.play().catch(() => {});
    }

    // Restart with normal advancement timer
    startAdvancementTimer(ADVANCEMENT_TIME_NORMAL);
  }, [startAdvancementTimer]);

  // Handle clicking on the Nam marker - toggles pause/play
  const handleNamMarkerClick = useCallback(() => {
    if (!isStarted) return;
    
    if (isZoomedIn) {
      resumeVideo();
    } else {
      pauseVideo();
    }
  }, [isStarted, isZoomedIn, pauseVideo, resumeVideo]);

  const handleMarkerClick = useCallback((index: number) => {
    playVideo(index);
  }, [playVideo]);

  const handlePlaylistClick = useCallback((index: number) => {
    playVideo(index);
  }, [playVideo]);

  // Called when YouTube video is paused by user clicking on it
  const handleVideoPause = useCallback(() => {
    pauseVideo();
  }, [pauseVideo]);

  // Called when YouTube video ends
  const handleVideoEnd = useCallback(() => {
    if (videos.length === 0) return;
    
    const nextIndex = (activeIndexRef.current + 1) % videos.length;
    const nextVideoId = videos[nextIndex]?.id;
    const isPreloaded = preloadedIdsRef.current.has(nextVideoId);

    setActiveIndex(nextIndex);
    setIsZoomedIn(false);

    const duration = isPreloaded ? ADVANCEMENT_TIME_NORMAL : ADVANCEMENT_TIME_LOADING;
    startAdvancementTimer(duration);
  }, [videos, startAdvancementTimer]);

  // Called when user clicks play on the first video (initiates the experience)
  const handleFirstPlay = useCallback(() => {
    setIsStarted(true);
    
    // Play background music
    if (audioRef.current) {
      audioRef.current.play().catch(() => {});
    }

    // Start the advancement timer
    startAdvancementTimer(ADVANCEMENT_TIME_NORMAL);
  }, [startAdvancementTimer]);

  // Called by YouTubePlayer when a video is preloaded
  const handleVideoPreloaded = useCallback((videoId: string) => {
    preloadedIdsRef.current.add(videoId);
  }, []);

  if (videos.length === 0) {
    return (
      <div id="aroundtheworld-page">
        <div id="map" style={{ display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          Loading...
        </div>
      </div>
    );
  }

  return (
    <div id="aroundtheworld-page">
      <audio ref={audioRef} id="song" loop>
        <source src="/einmalumdiewelt.mp3" type="audio/mpeg" />
      </audio>

      <MapComponent
        videos={videos}
        activeIndex={activeIndex}
        onMarkerClick={handleMarkerClick}
        onNamMarkerClick={handleNamMarkerClick}
        isZoomedIn={isZoomedIn}
      />

      <Playlist
        videos={videos}
        activeIndex={activeIndex}
        isPlaying={isStarted && !isZoomedIn}
        onItemClick={handlePlaylistClick}
      />

      <YouTubePlayer
        videoIds={videoIds}
        activeVideoId={videos[activeIndex]?.id || ''}
        activeIndex={activeIndex}
        isStarted={isStarted}
        onPause={handleVideoPause}
        onEnd={handleVideoEnd}
        onFirstPlay={handleFirstPlay}
        onVideoPreloaded={handleVideoPreloaded}
      />

      <Link href="/" id="home-link">
        Back to Home
      </Link>
    </div>
  );
}

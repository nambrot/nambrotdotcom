'use client';

import { useEffect, useRef } from 'react';
import { VideoLocation } from '@/data/videos';

interface PlaylistProps {
  videos: VideoLocation[];
  activeIndex: number;
  isPlaying: boolean;
  onItemClick: (index: number) => void;
}

export default function Playlist({ videos, activeIndex, isPlaying, onItemClick }: PlaylistProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const itemRefs = useRef<(HTMLDivElement | null)[]>([]);

  // Auto-scroll to active item
  useEffect(() => {
    const activeItem = itemRefs.current[activeIndex];
    const container = containerRef.current;
    
    if (activeItem && container) {
      // Scroll the active item into view within the container
      const containerRect = container.getBoundingClientRect();
      const itemRect = activeItem.getBoundingClientRect();
      
      // Check if item is outside visible area
      if (itemRect.top < containerRect.top || itemRect.bottom > containerRect.bottom) {
        activeItem.scrollIntoView({ behavior: 'smooth', block: 'center' });
      }
    }
  }, [activeIndex]);

  return (
    <div id="playlist">
      <h1>Around the world with Nam</h1>
      <div className="playlist-container" ref={containerRef}>
        {videos.map((video, index) => (
          <div
            key={video.id}
            ref={(el) => { itemRefs.current[index] = el; }}
            className={`playlist-item ${index === activeIndex ? 'active' : ''} ${index === activeIndex && isPlaying ? 'playing' : ''}`}
            onClick={() => onItemClick(index)}
          >
            {video.name}
          </div>
        ))}
      </div>
    </div>
  );
}

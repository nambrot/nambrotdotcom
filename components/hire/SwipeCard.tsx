'use client';

import { useState, useRef, useEffect } from 'react';
import Image from 'next/image';

interface SwipeCardProps {
  onSwipeLeft: () => void;
  onSwipeRight: () => void;
}

export default function SwipeCard({ onSwipeLeft, onSwipeRight }: SwipeCardProps) {
  const cardRef = useRef<HTMLDivElement>(null);
  const [isDragging, setIsDragging] = useState(false);
  const [startX, setStartX] = useState(0);
  const [offsetX, setOffsetX] = useState(0);
  const [showTooltip, setShowTooltip] = useState(false);

  useEffect(() => {
    // Show tooltip on first visit
    const hasSeenTooltip = localStorage.getItem('swiped_hire_card');
    if (!hasSeenTooltip) {
      setShowTooltip(true);
      localStorage.setItem('swiped_hire_card', 'true');
    }
  }, []);

  const handleStart = (clientX: number) => {
    setIsDragging(true);
    setStartX(clientX);
    setShowTooltip(false);
  };

  const handleMove = (clientX: number) => {
    if (!isDragging) return;
    const diff = clientX - startX;
    setOffsetX(diff);
  };

  const handleEnd = () => {
    if (!isDragging) return;
    setIsDragging(false);

    const threshold = 80;
    if (offsetX > threshold) {
      // Swiped right - HIRE
      onSwipeRight();
    } else if (offsetX < -threshold) {
      // Swiped left - FIRE
      onSwipeLeft();
    } else {
      // Reset position
      setOffsetX(0);
    }
  };

  // Mouse events
  const onMouseDown = (e: React.MouseEvent) => handleStart(e.clientX);
  const onMouseMove = (e: React.MouseEvent) => handleMove(e.clientX);
  const onMouseUp = () => handleEnd();
  const onMouseLeave = () => {
    if (isDragging) handleEnd();
  };

  // Touch events
  const onTouchStart = (e: React.TouchEvent) => handleStart(e.touches[0].clientX);
  const onTouchMove = (e: React.TouchEvent) => handleMove(e.touches[0].clientX);
  const onTouchEnd = () => handleEnd();

  const rotation = offsetX / 20;
  const hireOpacity = Math.min(Math.max(offsetX / 70, 0), 1);
  const fireOpacity = Math.min(Math.max(-offsetX / 70, 0), 1);

  return (
    <div
      ref={cardRef}
      className="hire-card tinder-card"
      style={{
        transform: `translateX(${offsetX}px) rotate(${rotation}deg)`,
        cursor: isDragging ? 'grabbing' : 'grab',
        transition: isDragging ? 'none' : 'transform 0.3s ease-out',
      }}
      onMouseDown={onMouseDown}
      onMouseMove={onMouseMove}
      onMouseUp={onMouseUp}
      onMouseLeave={onMouseLeave}
      onTouchStart={onTouchStart}
      onTouchMove={onTouchMove}
      onTouchEnd={onTouchEnd}
    >
      {showTooltip && (
        <span className="tooltip show">Swipe me left or right.</span>
      )}
      
      <span className="hire-label" style={{ opacity: hireOpacity }}>HIRE</span>
      <span className="fire-label" style={{ opacity: fireOpacity }}>FIRE</span>
      
      <div className="card-image">
        <Image
          src="/images/profpic.jpg"
          alt="Nam Chu Hoai"
          width={300}
          height={300}
          priority
        />
      </div>
      
      <div className="metainfo">
        <span className="name">Nam</span>
        <span className="age">, 22</span>
        <span className="more-detail">
          <span className="title">Fullstack Developer</span>
        </span>
      </div>

      <div className="description">
        <header>About Nam Chu Hoai</header>
        <p>
          I&apos;m a freelance product developer specializing in full-stack web development, 
          building and shaping products from the ground up. My preferred stack is 
          Heroku/Ruby on Rails/Foundation Zurb/Backbone.js which I have found to be the 
          perfect balance between performance, development iteration speed and audience reach. 
          However, I pride myself on following a non-dogmatic approach of choosing the right 
          tool for the job.
        </p>
        <p>
          With my prior experience, I have come to appreciate how crucial the interplay 
          between product/customer/business is, so I make sure to have the best customized 
          solutions for my clients. You can read more about my previous work on my{' '}
          <a href="/about#categories:coder,worker,student;importance:4">about page</a>{' '}
          or just go ahead and swipe this card to the right
        </p>
      </div>
    </div>
  );
}

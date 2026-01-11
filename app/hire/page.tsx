'use client';

import { useState } from 'react';
import SwipeCard from '@/components/hire/SwipeCard';
import ContactForm from '@/components/hire/ContactForm';

type CardState = 'swipe' | 'hired' | 'fired';

export default function HirePage() {
  const [cardState, setCardState] = useState<CardState>('swipe');

  const handleSwipeRight = () => {
    setCardState('hired');
  };

  const handleSwipeLeft = () => {
    setCardState('fired');
  };

  return (
    <div className="hire-page">
      <nav className="topbar">
        <h1>hire me</h1>
      </nav>

      <section className="background">
        {cardState === 'swipe' && (
          <SwipeCard onSwipeLeft={handleSwipeLeft} onSwipeRight={handleSwipeRight} />
        )}

        {cardState === 'hired' && (
          <div className="hire-card result-card hired-card show">
            <header>
              <h3>So close</h3>
            </header>
            <p>
              Thanks for your interest. Please contact me via the form below or via 
              any of the services on the side bar.
            </p>
            <ContactForm variant="hire" />
          </div>
        )}

        {cardState === 'fired' && (
          <div className="hire-card result-card fired-card show">
            <header>
              <h3>Are you sure?</h3>
            </header>
            <p>
              If you have changed your mind or just want to chat, why don&apos;t you 
              fill out the form below or contact me via any of the services on the side bar.
            </p>
            <ContactForm variant="fire" />
          </div>
        )}
      </section>
    </div>
  );
}

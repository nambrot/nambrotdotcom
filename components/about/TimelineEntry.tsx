'use client'

import { useState } from 'react'
import { TimelineEntry as TimelineEntryType } from '@/data/timeline'

interface TimelineEntryProps {
  entry: TimelineEntryType
  visible: boolean
}

export default function TimelineEntry({ entry, visible }: TimelineEntryProps) {
  const [isFlipped, setIsFlipped] = useState(false)

  const handleClick = () => {
    if (entry.flippable) {
      setIsFlipped(!isFlipped)
    }
  }

  const handleCloseDetail = () => {
    setIsFlipped(false)
  }

  if (!visible) return null

  return (
    <li 
      className={`about-timeline-entry ${entry.flippable ? 'flippable' : ''} ${isFlipped ? 'flip' : ''}`}
      data-importance={entry.importance}
    >
      <div 
        className="about-timeline-entry-card"
        onClick={handleClick}
      >
        {entry.imageType === 'flickr' && entry.flickrAlbum ? (
          <a data-flickr-embed="true" href={entry.flickrAlbum} title={entry.title}>
            <img 
              src={entry.image} 
              style={{ height: '150px', width: '100%', objectFit: 'cover' }} 
              alt={entry.title} 
            />
          </a>
        ) : (
          <img 
            src={entry.image} 
            style={{ height: '150px', width: '100%', objectFit: 'cover' }} 
            alt={entry.title} 
          />
        )}
        <h5>{entry.title}</h5>
        <p dangerouslySetInnerHTML={{ __html: entry.description }} />
        <footer>
          <div className="location">{entry.location}</div>
          <div className="date">{entry.date}</div>
          <div className="timeline-entry-tags">
            {entry.tags.map(tag => `#${tag}`).join(' ')}
          </div>
        </footer>
      </div>

      {entry.flippable && entry.detail && isFlipped && (
        <div 
          className="about-timeline-entry-detail show"
          style={{ width: entry.detailWidth || '300%' }}
        >
          <button 
            onClick={handleCloseDetail}
            style={{
              position: 'absolute',
              top: '10px',
              right: '10px',
              background: 'none',
              border: 'none',
              fontSize: '24px',
              cursor: 'pointer',
              color: '#525252'
            }}
          >
            &times;
          </button>
          <div className="margin-5" dangerouslySetInnerHTML={{ __html: entry.detail }} />
        </div>
      )}
    </li>
  )
}

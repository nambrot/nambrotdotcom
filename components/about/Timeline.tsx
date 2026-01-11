'use client'

import { useState, useEffect } from 'react'
import { timelineEntries } from '@/data/timeline'
import TimelineEntry from './TimelineEntry'
import CategoryFilter from './CategoryFilter'

export default function Timeline() {
  const [selectedCategories, setSelectedCategories] = useState<string[]>(['job'])
  const [importanceLevel, setImportanceLevel] = useState(2)

  const isEntryVisible = (entry: typeof timelineEntries[0]) => {
    // Check importance
    if (entry.importance > importanceLevel) return false

    // Check category match
    if (selectedCategories.length === 0) return true
    return entry.tags.some(tag => selectedCategories.includes(tag))
  }

  // Load Flickr embed script
  useEffect(() => {
    const script = document.createElement('script')
    script.src = '//embedr.flickr.com/assets/client-code.js'
    script.async = true
    script.charset = 'utf-8'
    document.body.appendChild(script)
    return () => {
      document.body.removeChild(script)
    }
  }, [])

  return (
    <div id="about-page">
      <CategoryFilter
        selectedCategories={selectedCategories}
        onCategoryChange={setSelectedCategories}
        importanceLevel={importanceLevel}
        onImportanceChange={setImportanceLevel}
      />

      <ul id="about-timeline">
        {timelineEntries.map((entry) => (
          <TimelineEntry
            key={entry.id}
            entry={entry}
            visible={isEntryVisible(entry)}
          />
        ))}
      </ul>

      <footer style={{ fontSize: '0.5em' }}>
        Images from Lemon Liu, Eric Milet, Kris Khoury from The Noun Project
      </footer>
    </div>
  )
}

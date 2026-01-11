import { Metadata } from 'next'
import Timeline from '@/components/about/Timeline'

export const metadata: Metadata = {
  title: 'About - Nambrot.com',
  description: 'Learn more about Nam Chu Hoai - code, travel, and career',
}

export default function AboutPage() {
  return (
    <main>
      <Timeline />
    </main>
  )
}

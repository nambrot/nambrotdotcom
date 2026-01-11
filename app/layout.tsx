import type { Metadata } from 'next'
import './globals.css'
import Sidebar from '@/components/layout/Sidebar'
import MobileNav from '@/components/layout/MobileNav'

export const metadata: Metadata = {
  title: 'Nambrot.com',
  description: 'Nam Chu Hoai doing things that you can read about and stuff',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>
        <div className="off-canvas-wrap">
          <div className="inner-wrap">
            <MobileNav />
            <div className="hide-on-mobile">
              <Sidebar />
            </div>
            <div id="container">
              {children}
            </div>
          </div>
        </div>
      </body>
    </html>
  )
}

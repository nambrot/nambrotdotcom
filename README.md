# nambrot.com

Personal website of Nam Chu Hoai, built with Next.js 14 and TypeScript. Originally a Rails 4.2 application, migrated to a modern static site for hosting on Vercel.

## Tech Stack

- **Framework**: Next.js 14 (App Router)
- **Language**: TypeScript
- **Styling**: Tailwind CSS + Custom CSS
- **Maps**: React-Leaflet / Leaflet
- **Content**: Markdown + YAML
- **Deployment**: Vercel (static export)

## Getting Started

### Prerequisites

- Node.js 18.x or later
- npm 9.x or later

### Installation

```bash
# Clone the repository
git clone https://github.com/nambrot/nambrotdotcom.git
cd nambrotdotcom/next-app

# Install dependencies
npm install
```

### Development

```bash
# Start the development server
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

### Build

```bash
# Build for production (generates static export)
npm run build
```

The build process:
1. Runs `prebuild` script to generate `data/postsData.ts` from YAML
2. Builds the Next.js application
3. Exports static HTML to the `out/` directory

### Preview Production Build

```bash
# After building, serve the static files
npx serve out
```

## Project Structure

```
next-app/
├── app/                      # Next.js App Router pages
│   ├── page.tsx              # Blog index (/)
│   ├── layout.tsx            # Root layout with sidebar
│   ├── globals.css           # Global styles
│   ├── about/                # About page with timeline
│   ├── aroundtheworld/       # Interactive video map
│   ├── hire/                 # Hire page with swipe card
│   ├── mapsoffline/          # Legacy app page
│   ├── namsremote/           # Legacy app page
│   ├── posts/[slug]/         # Dynamic blog post pages
│   └── resume/               # Resume page
├── components/               # React components
│   ├── layout/               # Sidebar, MobileNav
│   ├── posts/                # PostCard, PostContent, etc.
│   ├── about/                # Timeline, CategoryFilter
│   ├── aroundtheworld/       # Map, Playlist, YouTubePlayer
│   └── hire/                 # SwipeCard, ContactForm
├── content/
│   └── posts/                # Markdown blog posts (*.md)
├── data/
│   ├── posts.yaml            # Blog post metadata
│   ├── postsData.ts          # Auto-generated posts data
│   ├── timeline.ts           # About page timeline entries
│   └── videos.ts             # Around the World video data
├── lib/
│   ├── posts.ts              # Post loading utilities
│   └── markdown.ts           # Markdown processing
├── public/
│   ├── images/               # Static images
│   └── einmalumdiewelt.mp3   # Background music
├── scripts/
│   └── generatePostsData.js  # Pre-build script
├── next.config.js            # Next.js configuration
├── tailwind.config.ts        # Tailwind configuration
└── tsconfig.json             # TypeScript configuration
```

## Routes

| Route | Description |
|-------|-------------|
| `/` | Blog index with tag filtering |
| `/posts/[slug]` | Individual blog posts |
| `/about` | About page with interactive timeline |
| `/hire` | Hire page with Tinder-style swipe card |
| `/aroundtheworld` | Interactive map with travel videos |
| `/resume` | Resume/CV page |
| `/namsremote` | Legacy iOS app page |
| `/mapsoffline` | Legacy iOS app page |

## Contributing

### Adding a Blog Post

1. Create a new Markdown file in `content/posts/` named `{id}.md`
2. Add metadata to `data/posts.yaml`:
   ```yaml
   - id: 32
     title: Your Post Title
     summary: A brief summary of your post
     tags:
       - Tag1
       - Tag2
     created_at: '2024-01-15T12:00:00.000Z'
   ```
3. The build process will automatically generate the route

### Adding Timeline Entries

Edit `data/timeline.ts` to add new entries:

```typescript
{
  title: "Event Title",
  time: "January 2024",
  importance: 4,
  image: "/images/your-image.jpg",
  categories: ["coder", "worker"],
  description: "Description of the event",
  detail: "Longer description shown on click",
}
```

### Adding Travel Videos

Edit `data/videos.ts` to add new video locations:

```typescript
{
  id: "YouTubeVideoId",
  name: "Location Name",
  description: "https://youtu.be/YouTubeVideoId",
  coordinates: [longitude, latitude]
}
```

### Modifying Styles

- Global styles: `app/globals.css`
- Component-specific styles: Use Tailwind classes or add to globals.css
- Resume styles: `app/resume/resume.css`

## Deployment

The site is configured for static export and can be deployed to any static hosting provider.

### Vercel (Recommended)

1. Connect your GitHub repository to Vercel
2. Vercel will automatically detect Next.js and configure the build
3. Deploy!

### Other Platforms

```bash
# Build the static export
npm run build

# The `out/` directory contains all static files
# Upload to your hosting provider
```

## Environment Variables

No environment variables are required for basic operation. The site is fully static.

## License

MIT

## Author

Nam Chu Hoai - [nambrot.com](https://nambrot.com)

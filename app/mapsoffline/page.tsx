export const metadata = {
  title: 'Maps Offline - nambrot.com',
};

export default function MapsOfflinePage() {
  return (
    <article className="blog_post">
      <h2>Maps Offline</h2>
      <p>
        It should seem obvious, but Maps Offline hasn&apos;t been available in years. 
        However, it is still my biggest traffic driver, which is the reason why you 
        are seeing this probably. Why don&apos;t you check out what the rage was all about:
      </p>
      <div className="flex-video" style={{ position: 'relative', paddingBottom: '56.25%', height: 0, overflow: 'hidden', maxWidth: '100%', marginTop: '20px' }}>
        <iframe
          style={{ position: 'absolute', top: 0, left: 0, width: '100%', height: '100%' }}
          src="https://www.youtube.com/embed/rbVygHZMUvg"
          frameBorder="0"
          allowFullScreen
          title="Maps Offline Demo"
        />
      </div>
    </article>
  );
}

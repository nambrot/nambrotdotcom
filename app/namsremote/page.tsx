export const metadata = {
  title: "Nam's Remote - nambrot.com",
};

export default function NamsRemotePage() {
  return (
    <article className="blog_post">
      <h2>Nam&apos;s Remote</h2>
      <p>
        Nam&apos;s Remote is unfortunately not available anymore. I no longer had the 
        resources to keep maintaining it. I still feel nostalgic about it though. 
        If you too, relive the good times with this video:
      </p>
      <div className="flex-video" style={{ position: 'relative', paddingBottom: '56.25%', height: 0, overflow: 'hidden', maxWidth: '100%', marginTop: '20px' }}>
        <iframe
          style={{ position: 'absolute', top: 0, left: 0, width: '100%', height: '100%' }}
          src="https://www.youtube.com/embed/nMl1uPFDzj0"
          frameBorder="0"
          allowFullScreen
          title="Nam's Remote Demo"
        />
      </div>
    </article>
  );
}

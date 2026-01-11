'use client'

import { useEffect } from 'react'

interface DisqusCommentsProps {
  shortname: string
  identifier: string
  title: string
  url: string
}

export default function DisqusComments({ shortname, identifier, title, url }: DisqusCommentsProps) {
  useEffect(() => {
    // Reset Disqus if it already exists
    if (typeof window !== 'undefined' && (window as any).DISQUS) {
      (window as any).DISQUS.reset({
        reload: true,
        config: function(this: any) {
          this.page.identifier = identifier
          this.page.url = url
          this.page.title = title
        }
      })
      return
    }

    // Load Disqus script
    const script = document.createElement('script')
    script.src = `https://${shortname}.disqus.com/embed.js`
    script.setAttribute('data-timestamp', String(+new Date()))
    script.async = true
    document.body.appendChild(script)

    return () => {
      // Cleanup
      const disqusThread = document.getElementById('disqus_thread')
      if (disqusThread) {
        disqusThread.innerHTML = ''
      }
    }
  }, [shortname, identifier, title, url])

  return (
    <>
      <div id="disqus_thread"></div>
      <noscript>
        Please enable JavaScript to view the{' '}
        <a href="https://disqus.com/?ref_noscript">comments powered by Disqus.</a>
      </noscript>
    </>
  )
}

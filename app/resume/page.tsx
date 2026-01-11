import './resume.css';

export const metadata = {
  title: 'Nam Chu Hoai - Resume',
};

export default function ResumePage() {
  return (
    <div id="resume-page">
      <div id="header">
        <h1>nam chu hoai</h1>
        <div id="contact">
          <ul>
            <li>Phone<strong>+1 605 644 6626</strong></li>
            <li>Email<strong><a href="mailto:nambrot@gmail.com" target="_blank" rel="noopener noreferrer">nambrot@gmail.com</a></strong></li>
            <li>Web<strong><a href="https://nambrot.com" target="_blank" rel="noopener noreferrer">nambrot.com</a></strong></li>
            <li>Github<strong><a href="https://github.com/nambrot" target="_blank" rel="noopener noreferrer">github.com/nambrot</a></strong></li>
            <li>Location <strong>San Francisco</strong></li>
          </ul>
        </div>
      </div>

      <div id="highlights-and-objective">
        <div className="section" id="highlights">
          <div className="title"><h2>HIGHLIGHTS</h2></div>
          <div className="item">
            <ul>
              <li>Experienced in planning, conceptualizing, developing, deploying and maintaining modern web applications.</li>
              <li>Deep knowledge from cutting-edge frontend technologies all the way to database modeling with traditional SQL databases and NoSQL data stores.</li>
              <li>Production experience in Ruby, Ruby on Rails, Javascript, React, Kubernetes, Python, Scala, Java</li>
            </ul>
          </div>
        </div>
        <div className="section" id="objective">
          <div className="title"><h2>OBJECTIVE</h2></div>
          <p>
            Use software technology to achieve high impact by creating scalable information systems. Continuously 
            expand skillset to achieve such objective with higher scale, quality and reliability.
          </p>
          <p>Currently focusing on fundamentals such as FP, stream processing and other data-related workloads. For more details on my projects, check out <a className="blue-link" href="/about#categories:coder,job;importance:3">nambrot.com/about</a></p>
        </div>
      </div>

      <div className="section" id="experience">
        <div className="title"><h2>EXPERIENCE</h2></div>
        <div className="item">
          <h3><strong><a href="http://www.wellframe.com" target="_blank" rel="noopener noreferrer">Wellframe</a></strong> - Senior Software Engineer</h3>
          <h4>July 2014 - January 2018</h4>
          <ul>
            <li>Founded the team which established Wellframe as a full healthcare enterprise application with major clients, including Fortune 100 and FTSE 100 companies, and pioneered efficient productization of clinical models and workflows</li>
            <li>Architected, extended and maintained Ruby on Rails-based backend that intelligently delivers rich interventions to mobile patient applications with conscious microservice extraction to Scala</li>
            <li>Created the React-based patient management dashboard for care managers to oversee their populations and gain insights into various segments by risk, engagement etc.</li>
            <li>Established testing and CI process enabling early regression detection and predictable Docker-based deploys with ultimate migration from AWS to GCP/Kubernetes</li>
            <li>Built a HIPPA-compliant monitoring/logging pipeline based upon Kinesis/Elasticsearch/Kibana and eventually Stackdriver/BigQuery</li>
          </ul>
        </div>
        <div className="item">
          <h3><strong><a href="http://www.credport.org" target="_blank" rel="noopener noreferrer">Webcred/Credport</a></strong> - Co-Founder</h3>
          <h4>May 2012 - April 2013</h4>
          <ul>
            <li>Conceived, raised funding for and built a trust platform for Sharing Economy marketplaces</li>
            <li>Built data normalization across popular third parties, very generalized API design for reputation data and served in a Ruby on Rails based backend</li>
            <li>Architected storage in Neo4j as well as PostgreSQL by writing ActiveRecord extensions</li>
            <li>Received funding from Highland Capital Partners and Startupbootcamp Berlin</li>
          </ul>
        </div>
        <div className="item">
          <h3><strong><a href="https://en.wikipedia.org/wiki/Apture" target="_blank" rel="noopener noreferrer">Apture</a></strong> - Software Engineering Intern</h3>
          <h4>May 2011 - July 2011</h4>
          <ul>
            <li>Contributed 3rd party integrations to Apture&apos;s highlighting product with partners like WolframAlpha.</li>
            <li>Improved performance of queries by orders of magnitude including to Google Local and Wikipedia in Apture&apos;s Python back-end</li>
            <li>Apture was acquired by Google in October 2011</li>
          </ul>
        </div>
        <div className="item">
          <h3><strong><a href="/namsremote">Nam&apos;s Remote</a></strong> - iOS Developer</h3>
          <h4>Spring 2009</h4>
          <ul>
            <li>Designed, developed and sold a remote control iPhone application</li>
            <li>First-of-class use of the accelerometer to steer racing games</li>
            <li>Built a java-based server that communicated to the client via a custom UDP protocol.</li>
          </ul>
        </div>
      </div>

      <div className="section" id="education">
        <div className="title"><h2>EDUCATION</h2></div>
        <div className="item">
          <h3><strong>Boston University</strong> - Bachelor of Science (BSc.) in Computer Science</h3>
          <h4>Sep 2010 - May 2014</h4>
          <ul>
            <li>Trustee Scholarship (full-ride merit scholarship) Recipient</li>
            <li>Part of the Kilachand Honors College, which included rigorous multi-disciplinary coursework in the humanities, social sciences and natural sciences.</li>
            <li>Computer science coursework focused on fundamental computing theory, combinatorics and machine learning/data mining.</li>
          </ul>
        </div>
      </div>

      <div className="section" id="projects">
        <div className="title"><h2>OTHER ACCOMPLISHMENTS</h2></div>
        <div className="item">
          <h3><strong>Battlehack 2014 Finalist</strong></h3>
          <h4>November 2014</h4>
          <p>Placed 1st in the Battlehack Boston hackathon and proceeded to place 3rd in the Global Battlehack Finals in San Jose.</p>
        </div>
        <div className="item">
          <h3><strong>START Scholarship Recipient</strong></h3>
          <h4>2007 - 2010</h4>
          <p>Awarded for high-achieving, community-oriented high school students with ethnic backgrounds in Germany.</p>
        </div>
      </div>
    </div>
  );
}

import Accordion from "../components/Accordion";
import Card from "../components/Card";
import Footer from "../components/Footer";

export default function HomePage() {
  return (
    <>
      <div className="flex justify-center items-center h-screen p-4">
        <h1 className="text-center p-4">Listen to your documents.</h1>
        <h2 className="text-center p-4">
          Turn your documents into podcasts and listen on the go.
        </h2>

        <div className="flex flex-wrap gap-4">
          <div className="container text-center">
            <div className="row">
              <div className="col">
                <Card
                  cardTitle="Perfect For Audio Learners"
                  cardText="Transform your reading materials into engaging audio content. Ideal for students, professionals, and anyone who prefers listening to reading. Upload documents, choose a voice, and listen anywhere."
                  cardHeight="250px"
                ></Card>
              </div>
              <div className="col">
                <Card
                  cardTitle="Boost Productivity"
                  cardText="Maximize your time by consuming content while commuting, exercising, or completing other tasks. Convert lengthy documents into audio files and make the most of your busy schedule. Take charge of your learning!"
                  cardHeight="250px"
                ></Card>
              </div>
              <div className="col">
                <Card
                  cardTitle="Accessibility For Everyone"
                  cardText="Make your content accessible to those with visual impairments or reading difficulties. Our natural-sounding voice technology delivers clear, engaging audio from any text document."
                  cardHeight="250px"
                ></Card>
              </div>
            </div>
          </div>
        </div>
        <Accordion
          AccordionTitleName="main"
          AccordionTitleText="Why use this tool?"
          AccordionNumber="one"
          AccordionBody={
            <div className="space-y-3">
              <p>Convert your documents into audio to:</p>
              <ul className="list-disc pl-5 space-y-2">
                <li>Consume information while commuting or exercising</li>
                <li>
                  Process content more effectively if you're an auditory learner
                </li>
                <li>
                  Make documents accessible for those with visual impairments
                </li>
                <li>Save time by listening to documents while multitasking</li>
                <li>Reduce eye strain from extended screen time</li>
                <li>
                  Improve comprehension by hearing content in a natural voice
                </li>
              </ul>
            </div>
          }
        ></Accordion>
        <Accordion
          AccordionTitleName="features"
          AccordionTitleText="Features and Capabilities"
          AccordionNumber="two"
          AccordionBody={
            <div className="space-y-3">
              <p>Our document podcaster offers:</p>
              <ul className="list-disc pl-5 space-y-2">
                <li>Support for multiple document formats (PDF, DOCX, TXT)</li>
                <li>Natural-sounding voice synthesis with adjustable speeds</li>
                <li>Offline listening for downloaded audio files</li>
                <li>Custom voice profiles for personalized listening</li>
              </ul>
            </div>
          }
        ></Accordion>
        <Accordion
          AccordionTitleName="getstarted"
          AccordionTitleText="How to Get Started"
          AccordionNumber="three"
          AccordionBody={
            <div className="space-y-3">
              <p>Getting started is simple:</p>
              <ul className="list-disc pl-5 space-y-2">
                <li>Upload your document using the file selector</li>
                <li>Choose your preferred voice and playback settings</li>
                <li>Click "Convert" and wait for processing to complete</li>
                <li>Press play to listen or download for offline access</li>
                <li>Use the player controls to navigate through your audio</li>
                <li>Save your conversion for future access in your library</li>
              </ul>
            </div>
          }
        ></Accordion>
        <Footer></Footer>
      </div>
    </>
  );
}

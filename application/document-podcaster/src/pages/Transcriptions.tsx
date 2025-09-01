import { NavLink } from "react-router-dom";
import Button from "../components/Buttons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faXmark } from "@fortawesome/free-solid-svg-icons";

interface Transcription {
  transcriptionid: number;
  transcriptionUrl: string;
  transcriptionName: string;
  transcriptionFileName: string;
  text: string;
}

export default function Transcriptions() {
  const Transcriptions: Transcription[] = [
    // {
    //   transcriptionid: 1,
    //   transcriptionUrl: "https://example.com/transcription1",
    //   transcriptionName: "Transcription 1",
    //   transcriptionFileName: "example.docx",
    //   text: "Transcription 1",
    // },
    // {
    //   transcriptionid: 2,
    //   transcriptionUrl: "https://example.com/transcription2",
    //   transcriptionName: "Transcription 2",
    //   transcriptionFileName: "docx",
    //   text: "Transcription 2",
    // },
    // {
    //   transcriptionid: 3,
    //   transcriptionUrl: "https://example.com/transcription3",
    //   transcriptionName: "Transcription 3",
    //   transcriptionFileName: "docx",
    //   text: "Transcription 3",
    // },
    // {
    //   transcriptionid: 4,
    //   transcriptionUrl: "https://example.com/transcription4",
    //   transcriptionName: "Transcription 4",
    //   transcriptionFileName: "example.docx",
    //   text: "Transcription 4",
    // },
    // {
    //   transcriptionid: 5,
    //   transcriptionUrl: "https://example.com/transcription5",
    //   transcriptionName: "Transcription 5",
    //   transcriptionFileName: "example.docx",
    //   text: "Transcription 5",
    // },
    // {
    //   transcriptionid: 6,
    //   transcriptionUrl: "https://example.com/transcription6",
    //   transcriptionName: "Transcription 6",
    //   transcriptionFileName: "example.docx",
    //   text: "Transcription 6",
    // },
    // {
    //   transcriptionid: 7,
    //   transcriptionUrl: "https://example.com/transcription7",
    //   transcriptionName: "Transcription 7",
    //   transcriptionFileName: "example.docx",
    //   text: "Transcription 7",
    // },
    // {
    //   transcriptionid: 8,
    //   transcriptionUrl: "https://example.com/transcription8",
    //   transcriptionName: "Transcription 8",
    //   transcriptionFileName: "example.docx",
    //   text: "Transcription 8",
    // },
    // {
    //   transcriptionid: 9,
    //   transcriptionUrl: "https://example.com/transcription9",
    //   transcriptionName: "Transcription 9",
    //   transcriptionFileName: "example.docx",
    //   text: "Transcription 9",
    // },
    // {
    //   transcriptionid: 10,
    //   transcriptionUrl: "https://example.com/transcription10",
    //   transcriptionName: "Transcription 10",
    //   transcriptionFileName: "example.docx",
    //   text: "Transcription 10",
    // },
    // {
    //   transcriptionid: 11,
    //   transcriptionUrl: "https://example.com/transcription11",
    //   transcriptionName: "Transcription 11",
    //   transcriptionFileName: "example.docx",
    //   text: "Transcription 11",
    // },
    // {
    //   transcriptionid: 12,
    //   transcriptionUrl: "https://example.com/transcription12",
    //   transcriptionName: "Transcription 12",
    //   transcriptionFileName: "example.docx",
    //   text: "Transcription 12",
    // },
  ];
  return (
    <>
      {Transcriptions.length > 0 ? (
        <table className="table text-center">
          <thead>
            <tr>
              <th scope="col">ID #</th>
              <th scope="col">Transcription Name</th>
              <th scope="col">File</th>
              <th scope="col">Download</th>
              <th scope="col"></th>
            </tr>
          </thead>
          <tbody>
            {Transcriptions.map((transcription) => (
              <tr>
                <th scope="row">{transcription.transcriptionid}</th>
                <td>{transcription.transcriptionName}</td>
                <td>{transcription.transcriptionFileName}</td>
                <td>{transcription.transcriptionUrl}</td>
                <td>
                  <FontAwesomeIcon icon={faXmark} />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      ) : (
        <div
          className="d-flex flex-column justify-content-center align-items-center"
          style={{ minHeight: "60vh" }}
        >
          <h1 className="mb-4 text-center">No transcriptions yet.</h1>
          <NavLink to="/transcribe">
            <Button buttonColour="danger" buttonText="Start Transcribing Now" />
          </NavLink>
        </div>
      )}
    </>
  );
}

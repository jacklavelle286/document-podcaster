type Transcription = {
  transcriptionid: number;
  transcriptionUrl: string;
  transcriptionFileName: string;
  transcriptionName: string;
};

type Props = {
  transcription: Transcription;
};

export default function TranscriptionObject({ transcription }: Props) {
  return (
    <>
        {transcription.transcriptionName}
        {transcription.transcriptionFileName}
        {transcription.transcriptionUrl}
        {transcription.transcriptionid}
    </>
  );
}

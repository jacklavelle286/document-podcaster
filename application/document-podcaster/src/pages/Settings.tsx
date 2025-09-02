import Card from "../components/Card";
import Button from "../components/Buttons";

export default function Settings() {
  const languages = ["English", "Spanish", "French", "Greek"];
  return (
    <>
      <h2 className="p-4 text-center">Settings ⚙️</h2>
      <form
        className="px-5 py-4 text-center"
        style={{
          width: "60%",
          margin: "0 auto",
        }}
      >
        <div className="mb-3 form-check">
          <input
            type="checkbox"
            className="form-check-input"
            id="exampleCheck1"
          />
          <label className="form-check-label" htmlFor="exampleCheck1">
            Turbo-Mode
          </label>
        </div>
        <select
          className="form-select my-4"
          aria-label="Default select example"
        >
          <option selected>Select a Transcription Language </option>
          {languages.map((language, id) => (
            <option key={id} value={language}>{language}</option>
          ))}
        </select>
        <Button
          buttonColour="primary"
          buttonText="Save Changes"
          buttonType="submit"
        ></Button>
      </form>
    </>
  );
}
/* 
Yes, the map of languages is correct. 
You are iterating over the `languages` array and rendering an <option> for each language with a unique `key` and `value`.
*/
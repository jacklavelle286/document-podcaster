export default function TranscribeForm() {
  return (
    <form>
    <div className="mb-3">
      <label htmlFor="voice-type" className="form-label">
        Voice Type
      </label>
      <select className="form-select" id="voice-type" aria-label="Default select example">
        <option value="" selected>Open this select menu</option>
        <option value="1">One</option>
        <option value="2">Two</option>
        <option value="3">Three</option>
      </select>
      <div id="emailHelp" className="form-text">
        Select which voice you'd like your transcription to be read in.
      </div>
    </div>
      <div className="mb-3">
        <label htmlFor="exampleInputPassword1" className="form-label">
          Password
        </label>
        <input
          type="password"
          className="form-control"
          id="exampleInputPassword1"
        />
      </div>
      <div className="mb-3 form-check">
        <input
          type="checkbox"
          className="form-check-input"
          id="exampleCheck1"
        />
        <label className="form-check-label" htmlFor="exampleCheck1">
          Check me out
        </label>
      </div>
      <button type="submit" className="btn btn-primary">
        Submit
      </button>
    </form>
  );
}

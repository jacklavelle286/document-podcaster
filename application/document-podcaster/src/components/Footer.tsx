import Button from "./Buttons";
import { NavLink } from "react-router-dom";

export default function Footer() {
  return (
    <div className="d-flex flex-column justify-content-center align-items-center p-4 vh-10">
      <h1 className="text-center mb-4">Start Transcribing now!</h1>
      <NavLink to="/transcribe">
        <Button buttonColour="success" buttonText="Start Transcribing Now" />
      </NavLink>
    </div>
  );
}

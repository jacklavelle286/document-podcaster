import Button from "./Buttons";
import { NavLink } from "react-router-dom";

const linkStyle = () => ({
  textDecoration: "none",
});

export default function NavBar() {
  return (
    <>
      <nav className="navbar navbar-expand-lg bg-body-tertiary">
        <div className="container-fluid">
          <a className="navbar-brand mx-4" href="#">
            <img
              src="../src/images/logo.png"
              width="30"
              height="30"
              alt=""
              className="me-2"
            />
            <NavLink to="/home" style={linkStyle}>
              Document Podcaster
            </NavLink>
          </a>
          <button
            className="navbar-toggler"
            type="button"
            data-bs-toggle="collapse"
            data-bs-target="#navbarSupportedContent"
            aria-controls="navbarSupportedContent"
            aria-expanded="false"
            aria-label="Toggle navigation"
          >
            <span className="navbar-toggler-icon"></span>
          </button>
          <div className="collapse navbar-collapse" id="navbarSupportedContent">
            <ul className="navbar-nav me-auto mb-2 mb-lg-0">
              <li className="nav-item">
                <NavLink to="/transcribe" style={linkStyle}>
                  <Button
                    buttonText="Transcribe"
                    buttonColour="primary"
                    buttonSolid={false}
                  ></Button>
                </NavLink>
              </li>
              <li className="nav-item">
                <NavLink to="/transcriptions" style={linkStyle}>
                  <Button
                    buttonText="Transcriptions"
                    buttonColour="danger"
                    buttonSolid={false}
                  ></Button>
                </NavLink>
              </li>
              <li className="nav-item">
                <a className="nav-link" href="#"></a>
              </li>
              <li className="nav-item dropdown">
                  <a
                    className="nav-link dropdown-toggle"
                    href="#"
                    role="button"
                    data-bs-toggle="dropdown"
                    aria-expanded="false"
                  >
                    Settings
                  </a>
                <ul className="dropdown-menu">
                  <li>
                    <NavLink to="/settings" style={linkStyle}>
                      <a className="dropdown-item" href="#">
                        User Settings
                      </a>
                    </NavLink>
                  </li>
                  <li>
                    <NavLink to="/documentation" style={linkStyle}>
                      <a className="dropdown-item" href="#">
                        Documentation
                      </a>
                    </NavLink>
                  </li>
                  <li>
                    <hr className="dropdown-divider"></hr>
                  </li>
                  <li>
                    <a className="dropdown-item"  href="https://github.com/jacklavelle286/document-podcaster#" target="_blank">
                      View Source Code
                    </a>
                  </li>
                </ul>
              </li>
            </ul>
            <form className="d-flex" role="search">
              <input
                className="form-control me-2"
                type="search"
                placeholder="Search for Transcriptions..."
                aria-label="Search"
              />
              <Button
                buttonText="Search"
                buttonColour="success"
                buttonSolid={false}
                buttonType="submit"
              ></Button>
            </form>
          </div>
        </div>
      </nav>
    </>
  );
}

import { Routes, Route, Outlet } from "react-router-dom";
import NavBar from "./components/NavBar";
import Documentation from "./pages/Documentation";
import HomePage from "./pages/HomePage";
import Settings from "./pages/Settings";
import Transcribe from "./pages/Transcribe";
import Transcriptions from "./pages/Transcriptions";

function Layout() {
  return (
    <>
      <NavBar></NavBar>
    </>
  );
}

export default function App() {
  return (
    <Routes>
      <Route path="/" element={<Layout />}>
        <Route path="documentation" element={<Documentation />} />
        <Route path="home" element={<HomePage />} />
        <Route path="settings" element={<Settings />} />
        <Route path="transcribe" element={<Transcribe />} />
        <Route path="transcriptions" element={<Transcriptions />} />
      </Route>
    </Routes>
  );
}

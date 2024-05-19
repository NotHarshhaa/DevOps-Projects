import CircularProgress from "@mui/material/CircularProgress";

function MainLoadingScreen() {
  return (
    <div
      style={{
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        position: "fixed",
        backgroundColor: "#141414",
        opacity: 0.75,
        zIndex: 2,
      }}
    >
      <CircularProgress sx={{ color: "white" }} />
    </div>
  );
}

export default MainLoadingScreen;

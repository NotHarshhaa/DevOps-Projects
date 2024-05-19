import Slider from "@mui/material/Slider";
import { styled } from "@mui/material/styles";

import { formatTime } from "src/utils/common";

const StyledSlider = styled(Slider)({
  borderRadius: 0,
  "& .NetflixSlider-track": {
    backgroundColor: "red !important",
    border: 0,
  },
  "& .NetflixSlider-rail": {
    border: "none",
    backgroundColor: "white !important",
    opacity: 0.85,
  },
  "& .NetflixSlider-thumb": {
    borderRadius: "50%",
    height: 10,
    width: 10,
    backgroundColor: "red",
    "&:focus, &:hover, &.Netflix-active, &.Netflix-focusVisible": {
      boxShadow: "inherit",
      height: 15,
      width: 15,
    },
    "&:before": {
      display: "none",
      boxShadow: "0 2px 2px 0 #fff",
      height: 10,
      width: 10,
    },
  },
  // "& .NetflixSlider-valueLabel": {
  //   lineHeight: 1.2,
  //   fontSize: 12,
  //   background: "unset",
  //   padding: 0,
  //   width: 32,
  //   height: 32,
  //   borderRadius: "50% 50% 50% 0",
  //   backgroundColor: "#52af77",
  //   transformOrigin: "bottom left",
  //   transform: "translate(50%, -100%) rotate(-45deg) scale(0)",
  //   "&:before": { display: "none" },
  //   "&.NetflixSlider-valueLabelOpen": {
  //     transform: "translate(50%, -100%) rotate(-45deg) scale(1)",
  //   },
  //   "& > *": {
  //     transform: "rotate(45deg)",
  //   },
  // },
});

function PlayerSeekbar({
  playedSeconds,
  duration,
  seekTo,
}: {
  playedSeconds: number;
  duration: number;
  seekTo: (value: number) => void;
}) {
  return (
    <StyledSlider
      valueLabelDisplay="auto"
      valueLabelFormat={(v) => formatTime(v)}
      // components={{
      //   ValueLabel: ValueLabelComponent,
      // }}
      value={playedSeconds}
      max={duration}
      onChange={(_, value) => {
        seekTo(value as number);
      }}
    />
  );
}

export default PlayerSeekbar;

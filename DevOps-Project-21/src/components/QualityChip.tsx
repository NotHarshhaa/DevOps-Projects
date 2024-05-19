import Chip, { ChipProps } from "@mui/material/Chip";
export default function QualityChip({ sx, ...others }: ChipProps) {
  return (
    <Chip
      variant="outlined"
      {...others}
      sx={{
        borderRadius: "4px",
        p: 0.5,
        fontSize: 12,
        height: "100%",
        "& > span": { p: 0 },
        ...sx,
      }}
    />
  );
}

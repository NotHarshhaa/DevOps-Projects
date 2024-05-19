import Chip, { ChipProps } from "@mui/material/Chip";
export default function AgeLimitChip({ sx, ...others }: ChipProps) {
  return (
    <Chip
      {...others}
      sx={{
        borderRadius: 0,
        p: 0.5,
        fontSize: 12,
        height: "100%",
        "& > span": { p: 0 },
        ...sx,
      }}
      variant="outlined"
    />
  );
}

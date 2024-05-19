import Box from "@mui/material/Box";
import { ReactNode } from "react";

export default function MaturityRate({ children }: { children: ReactNode }) {
  return (
    <Box
      sx={{
        py: 1,
        pl: 1.5,
        pr: 3,
        fontSize: 22,
        display: "flex",
        alignItem: "center",
        color: "text.primary",
        border: "3px #dcdcdc",
        borderLeftStyle: "solid",
        bgcolor: "#33333399",
      }}
    >
      {children}
    </Box>
  );
}

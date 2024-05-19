import { forwardRef } from "react";
import Typography, { TypographyProps } from "@mui/material/Typography";

const MaxLineTypography = forwardRef<
  HTMLDivElement,
  TypographyProps & { maxLine: number }
>(({ maxLine, children, sx, ...others }, ref) => {
  return (
    <Typography
      ref={ref}
      sx={{
        overflow: "hidden",
        textOverflow: "ellipsis",
        display: "-webkit-box",
        WebkitLineClamp: maxLine,
        WebkitBoxOrient: "vertical",
        ...sx,
      }}
      {...others}
    >
      {children}
    </Typography>
  );
});

export default MaxLineTypography;

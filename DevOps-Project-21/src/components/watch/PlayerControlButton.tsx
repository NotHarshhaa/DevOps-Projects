import { forwardRef } from "react";

import IconButton, { IconButtonProps } from "@mui/material/IconButton";

const PlayerControlButton = forwardRef<HTMLButtonElement, IconButtonProps>(
  ({ children, ...others }, ref) => (
    <IconButton
      ref={ref}
      sx={{
        padding: { xs: 0.5, sm: 1 },
        "& svg, & span": { transition: "transform .3s" },
        "&:hover svg, &:hover span": {
          msTransform: "scale(1.3)",
          WebkitTransform: "scale(1.3)",
          transform: "scale(1.3)",
        },
      }}
      {...others}
    >
      {children}
    </IconButton>
  )
);

export default PlayerControlButton;

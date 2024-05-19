import Box from "@mui/material/Box";
import Typography from "@mui/material/Typography";
import Breadcrumbs, { BreadcrumbsProps } from "@mui/material/Breadcrumbs";

const Separator = (
  <Box
    component="span"
    sx={{
      width: 4,
      height: 4,
      borderRadius: "50%",
      bgcolor: "text.disabled",
    }}
  />
);

interface GenreBreadcrumbsProps extends BreadcrumbsProps {
  genres: string[];
}

export default function GenreBreadcrumbs({
  genres,
  ...others
}: GenreBreadcrumbsProps) {
  return (
    <Breadcrumbs separator={Separator} {...others}>
      {genres.map((genre, idx) => (
        <Typography key={idx} sx={{ color: "text.primary" }}>
          {genre}
        </Typography>
      ))}
    </Breadcrumbs>
  );
}

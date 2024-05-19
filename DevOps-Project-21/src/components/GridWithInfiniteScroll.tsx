import { useRef, useEffect } from "react";
import Grid from "@mui/material/Grid";
import Box from "@mui/material/Box";
import Container from "@mui/material/Container";
import Typography from "@mui/material/Typography";
import VideoItemWithHover from "./VideoItemWithHover";
import { CustomGenre, Genre } from "src/types/Genre";
import { PaginatedMovieResult } from "src/types/Common";
import useIntersectionObserver from "src/hooks/useIntersectionObserver";

interface GridWithInfiniteScrollProps {
  genre: Genre | CustomGenre;
  data: PaginatedMovieResult;
  handleNext: (page: number) => void;
}
export default function GridWithInfiniteScroll({
  genre,
  data,
  handleNext,
}: GridWithInfiniteScrollProps) {
  const intersectionRef = useRef<HTMLDivElement>(null);
  const intersection = useIntersectionObserver(intersectionRef);

  useEffect(() => {
    if (
      intersection &&
      intersection.intersectionRatio === 1 &&
      data.page < data.total_pages
    ) {
      handleNext(data.page + 1);
    }
  }, [intersection]);

  return (
    <>
      <Container
        maxWidth={false}
        sx={{
          px: { xs: "30px", sm: "60px" },
          pb: 4,
          pt: "150px",
          bgcolor: "inherit",
        }}
      >
        <Typography
          variant="h5"
          sx={{ color: "text.primary", mb: 2 }}
        >{`${genre.name} Movies`}</Typography>
        <Grid container spacing={2}>
          {data.results
            .filter((v) => !!v.backdrop_path)
            .map((video, idx) => (
              <Grid
                key={`${video.id}_${idx}`}
                item
                xs={6}
                sm={3}
                md={2}
                sx={{ zIndex: 1 }}
              >
                <VideoItemWithHover video={video} />
              </Grid>
            ))}
        </Grid>
      </Container>
      <Box sx={{ display: "hidden" }} ref={intersectionRef} />
    </>
  );
}

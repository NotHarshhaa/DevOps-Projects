import withPagination from "src/hoc/withPagination";
import { MEDIA_TYPE } from "src/types/Common";
import { CustomGenre, Genre } from "src/types/Genre";
import GridWithInfiniteScroll from "./GridWithInfiniteScroll";

interface GridPageProps {
  genre: Genre | CustomGenre;
  mediaType: MEDIA_TYPE;
}
export default function GridPage({ genre, mediaType }: GridPageProps) {
  const Component = withPagination(
    GridWithInfiniteScroll,
    mediaType,
    genre
  );
  return <Component />;
}

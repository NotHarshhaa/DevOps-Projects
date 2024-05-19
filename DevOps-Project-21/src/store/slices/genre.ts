import { TMDB_V3_API_KEY } from "src/constant";
import { Genre } from "src/types/Genre";
import { tmdbApi } from "./apiSlice";

const extendedApi = tmdbApi.injectEndpoints({
  endpoints: (build) => ({
    getGenres: build.query<Genre[], string>({
      query: (mediaType) => ({
        url: `/genre/${mediaType}/list`,
        params: { api_key: TMDB_V3_API_KEY },
      }),
      transformResponse: (response: { genres: Genre[] }) => {
        return response.genres;
      },
    }),
  }),
});

export const { useGetGenresQuery, endpoints: genreSliceEndpoints  } = extendedApi;

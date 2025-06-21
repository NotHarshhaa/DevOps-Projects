import React, { useState } from "react";

type PostsHomeProps = {};

const PostsHome: React.FC<PostsHomeProps> = () => {
  const [loading, setLoading] = useState(false);

  // stuff related to home page only
  return <div>Home Posts Wrapper</div>;
};
export default PostsHome;

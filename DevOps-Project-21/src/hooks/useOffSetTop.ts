import { useState, useEffect, useCallback } from "react";

export default function useOffSetTop(top: number) {
  const [offsetTop, setOffSetTop] = useState(false);
  const onScroll = useCallback(() => {
    if (window.pageYOffset > top) {
      setOffSetTop(true);
    } else {
      setOffSetTop(false);
    }
  }, [top]);

  useEffect(() => {
    window.addEventListener("scroll", onScroll);
    return () => {
      window.removeEventListener("scroll", onScroll);
    };
  }, [top]);

  return offsetTop;
}

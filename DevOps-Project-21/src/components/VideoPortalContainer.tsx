import { useRef } from "react";
import { motion } from "framer-motion";
import Portal from "@mui/material/Portal";

import VideoCardPortal from "./VideoCardPortal";
import MotionContainer from "./animate/MotionContainer";
import {
  varZoomIn,
  varZoomInLeft,
  varZoomInRight,
} from "./animate/variants/zoom/ZoomIn";
import { usePortalData } from "src/providers/PortalProvider";

export default function VideoPortalContainer() {
  const { miniModalMediaData, anchorElement } = usePortalData();
  const container = useRef(null);
  const rect = anchorElement?.getBoundingClientRect();

  const hasToRender = !!miniModalMediaData && !!anchorElement;
  let isFirstElement = false;
  let isLastElement = false;
  let variant = varZoomIn;
  if (hasToRender) {
    const parentElement = anchorElement.closest(".slick-active");
    const nextSiblingOfParentElement = parentElement?.nextElementSibling;
    const previousSiblingOfParentElement =
      parentElement?.previousElementSibling;
    if (!previousSiblingOfParentElement?.classList.contains("slick-active")) {
      isFirstElement = true;
      variant = varZoomInLeft;
    } else if (
      !nextSiblingOfParentElement?.classList.contains("slick-active")
    ) {
      isLastElement = true;
      variant = varZoomInRight;
    }
  }

  return (
    <>
      {hasToRender && (
        <Portal container={container.current}>
          <VideoCardPortal
            video={miniModalMediaData}
            anchorElement={anchorElement}
          />
        </Portal>
      )}
      <MotionContainer open={hasToRender} initial="initial">
        <motion.div
          ref={container}
          variants={variant}
          style={{
            zIndex: 1,
            position: "absolute",
            display: "inline-block",
            ...(rect && {
              top: rect.top + window.pageYOffset - 0.75 * rect.height,
              ...(isLastElement
                ? {
                    right: document.documentElement.clientWidth - rect.right,
                  }
                : {
                    left: isFirstElement
                      ? rect.left
                      : rect.left - 0.25 * rect.width,
                  }),
            }),
          }}
        />
      </MotionContainer>
    </>
  );
}

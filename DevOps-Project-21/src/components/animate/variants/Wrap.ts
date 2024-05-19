export const varWrapEnter = {
  animate: {
    transition: { staggerChildren: 0.1 },
  },
};

export const varWrapExit = {
  exit: {
    transition: { staggerChildren: 0.1 },
  },
};

export const varWrapBoth = {
  animate: {
    transition: { staggerChildren: 0.07, delayChildren: 0.1 },
  },
  exit: {
    transition: { staggerChildren: 0.05, staggerDirection: -1 },
  },
};

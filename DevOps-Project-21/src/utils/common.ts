export const getRandomNumber = (maxNumber: number) =>
  Math.floor(Math.random() * maxNumber);

export const formatMinuteToReadable = (minutes: number) => {
  const h = Math.floor(minutes / 60);
  const m = minutes - h * 60;

  if (h > 0) {
    return `${h}h ${m}m`;
  } else {
    return `${m}m`;
  }
};

export const formatBytes = (bytes: number, decimals: number = 2) => {
  if (!+bytes) return "0 Bytes";

  const k = 1024;
  const dm = decimals < 0 ? 0 : decimals;
  const sizes = [
    "Bytes",
    "KiB",
    "MiB",
    "GiB",
    "TiB",
    "PiB",
    "EiB",
    "ZiB",
    "YiB",
  ];

  const i = Math.floor(Math.log(bytes) / Math.log(k));

  return `${parseFloat((bytes / Math.pow(k, i)).toFixed(dm))} ${sizes[i]}`;
};

export const formatTime = (current: number) => {
  const h = Math.floor(current / 3600);
  const m = Math.floor((current - h * 3600) / 60);
  const s = Math.floor(current % 60);

  const sString = s < 10 ? "0" + s.toString() : s.toString();
  const mString = m < 10 ? "0" + m.toString() : m.toString();

  if (h > 0) {
    const hString = h < 10 ? "0" + h.toString() : h.toString();
    return `${hString}:${mString}:${sString}`;
  } else {
    return `${mString}:${sString}`;
  }
};

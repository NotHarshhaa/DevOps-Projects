import { atom } from "recoil";

const defaultUserState = {};

export const userState = atom({
  key: "userState",
  default: null,
});

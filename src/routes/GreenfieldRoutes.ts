import { IReq, IRes } from "./common/types";

async function deploy(req: IReq, res: IRes) {
  console.log("Deployu the mfg");

  return res.status(200).end();
}

export default {
  deploy,
} as const;

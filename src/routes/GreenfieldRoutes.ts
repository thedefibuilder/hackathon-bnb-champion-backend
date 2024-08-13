import { IReq, IRes } from "./common/types";
import { exec } from "node:child_process";
import { promisify } from "node:util";

const execAsync = promisify(exec);

async function deploy(req: IReq, res: IRes) {
  const { templateName, websiteName } = req.body;

  console.log(`Deploying ${templateName}...`);

  try {
    await execAsync(
      `cd templates/${templateName} && npm install && npm run build`
    );

    const { stdout } = await execAsync(
      `./deploy_to_greenfield.sh templates/${templateName}/dist gnfd://barabula-website-test/${websiteName}`
    );

    console.log(stdout);

    return res.status(200).end();
  } catch (error) {
    console.error(error);
    return res.status(500).end();
  }
}

export default {
  deploy,
} as const;

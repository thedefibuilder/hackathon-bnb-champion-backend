import { Router } from "express";

import Paths from "../common/Paths";
import GreenfieldRoutes from "./GreenfieldRoutes";

const apiRouter = Router();

const greenfieldRouter = Router();

greenfieldRouter.use(Paths.Greenfield.Deploy, GreenfieldRoutes.deploy);

apiRouter.use(Paths.Greenfield.Base, greenfieldRouter);

export default apiRouter;

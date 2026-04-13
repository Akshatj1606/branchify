import express from "express";
import { getEnvs, createEnv, stopBranch, deleteBranch } from "../controllers/branchControllers.js";

const router = express.Router();

router.get("/env", getEnvs);
router.post("/env", createEnv);
router.post("/env/:branch/stop", stopBranch);
router.delete("/env/:branch", deleteBranch);

export default router;

let environments = {};
let basePort = 3000;

// generate DB name from branch name
function generateDBName(branch) {
	return branch.replace(/-/g, "_") + "_db";
}

// to get next available port for new environment
function getNextPort() {
	basePort++;
	return basePort;
}

// here we will return all the environments with their details
const getEnvs = (req, res) => {
	res.json(environments);
};

// here we have create environment for given branch, we will generate port and db name based on branch name
const createEnv = (req, res) => {
	const { branch } = req.body;

	if (!branch) {
		return res.status(400).json({ error: "Branch is required" });
	}

	if (environments[branch]) {
		return res.status(400).json({ error: "Environment already exists" });
	}

	const port = getNextPort();
	const dbName = generateDBName(branch);

	environments[branch] = {
		port,
		dbName,
		status: "running",
		pid: Math.floor(Math.random() * 10000)
	};

	res.json({
		message: "Environment created",
		environment: environments[branch]
	});
};

// we will stop the environment for given branch, we will just change the status to stopped
const stopBranch = (req, res) => {
	const { branch } = req.params;

	if (!environments[branch]) {
		return res.status(404).json({ error: "Not found" });
	}

	environments[branch].status = "stopped";

	res.json({ message: "Environment stopped" });
};

// delete the environment for given branch, we will remove it from our environments object 
const deleteBranch = (req, res) => {
	const { branch } = req.params;

	if (!environments[branch]) {
		return res.status(404).json({ error: "Not found" });
	}

	delete environments[branch];

	res.json({ message: "Environment deleted" });
};

export { getEnvs, createEnv, stopBranch, deleteBranch };
function plan = buildfile
import matlab.buildtool.*;

plan = buildplan();

plan = addTask(plan, "ci:init",                    "Initialize project structure");
plan = addTask(plan, "ci:config",                  "Generate configuration files",     "ci:init");
plan = addTask(plan, "ci:parse",                   "Parse input data",                 "ci:init");
plan = addTask(plan, "ci:validate:AHRS_Voter",     "Validate AHRS Voter model",       ["ci:parse", "ci:config"]);
plan = addTask(plan, "ci:validate:Flight_Control", "Validate Flight Control model",    ["ci:parse", "ci:config"]);
plan = addTask(plan, "ci:transform",              "Transform validated data",          ["ci:validate:AHRS_Voter", "ci:validate:Flight_Control"]);
plan = addTask(plan, "ci:analyze:AHRS_Voter",     "Run analysis on AHRS Voter",       "ci:transform");
plan = addTask(plan, "ci:analyze:Flight_Control", "Run analysis on Flight Control",    "ci:transform");
plan = addTask(plan, "ci:report",                 "Generate report from analysis",     ["ci:analyze:AHRS_Voter", "ci:analyze:Flight_Control"]);
plan = addTask(plan, "ci:package",               "Package all outputs for delivery",   ["ci:report", "ci:transform"]);

end

function plan = addTask(plan, name, description, deps)
  import matlab.buildtool.*;

  plan(name) = Task( ...
      Description=description, ...
      Actions=@runTask);
  plan(name).Outputs = taskOutputFiles(name);

  if nargin > 3
      plan(name).Dependencies = deps;
      inputFiles = [];
      for i = 1:numel(deps)
          inputFiles = [inputFiles, taskOutputFiles(deps(i))]; %#ok<AGROW>
      end
      plan(name).Inputs = inputFiles;
  end
end

function files = taskOutputFiles(taskName)
  taskPath = strrep(taskName, ":", filesep);
  parts = split(taskName, ":");
  leafName = parts{end};
  taskDir = fullfile("results", taskPath);
  files = [
      fullfile(taskDir, leafName + "_output.txt"), ...
      fullfile(taskDir, leafName + "_log.txt")
      ];
end

function runTask(context)
  taskName = context.Task.Name;
  taskPath = strrep(taskName, ":", filesep);
  taskDir = fullfile(pwd, "results", taskPath);
  if ~isfolder(taskDir)
      mkdir(taskDir);
  end

  parts = split(taskName, ":");
  leafName = parts{end};
  ts = char(datetime("now"));

  fid = fopen(fullfile(taskDir, leafName + "_output.txt"), "w");
  fprintf(fid, "Task: %s\nDescription: %s\nCompleted at: %s\n", ...
      taskName, context.Task.Description, ts);
  fclose(fid);

  fid = fopen(fullfile(taskDir, leafName + "_log.txt"), "w");
  fprintf(fid, "[%s] %s executed successfully at %s\n", taskName, taskName, ts);
  fclose(fid);

  fprintf("  [%s] Output written to: %s\n", taskName, taskDir);
end

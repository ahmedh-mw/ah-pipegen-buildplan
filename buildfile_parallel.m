function plan = buildfile
import matlab.buildtool.*;

plan = buildplan();

% Sequential tasks
plan = addTask(plan, "ci:init",                    "Initialize project structure");
plan = addTask(plan, "ci:setup",                   "Setup project",                    "ci:init");

% Branch 1: Build
plan = addTask(plan, "ci:build_compile",           "Compile source code",              "ci:setup");
plan = addTask(plan, "ci:build_link",              "Link object files",                "ci:build_compile");
plan = addTask(plan, "ci:build_package",           "Package build artifacts",          "ci:build_link");

% Branch 2: Test
plan = addTask(plan, "ci:test_unit",               "Run unit tests",                   "ci:setup");
plan = addTask(plan, "ci:test_integration",        "Run integration tests",            "ci:test_unit");
plan = addTask(plan, "ci:test_coverage",           "Generate coverage report",         "ci:test_integration");

% Branch 3: Analysis
plan = addTask(plan, "ci:analysis_static",         "Run static analysis",              "ci:setup");
plan = addTask(plan, "ci:analysis_complexity",     "Compute complexity metrics",       "ci:analysis_static");
plan = addTask(plan, "ci:analysis_security",       "Run security scan",                "ci:analysis_complexity");

% Merge and final jobs
plan = addTask(plan, "ci:integrate",               "Integrate all branch results",     ["ci:build_package", "ci:test_coverage", "ci:analysis_security"]);
plan = addTask(plan, "ci:report",                  "Generate final report",            "ci:integrate");
plan = addTask(plan, "ci:deploy",                  "Deploy to staging",                "ci:report");

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

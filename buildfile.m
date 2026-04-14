function plan = buildfile
import matlab.buildtool.*;
import matlab.buildtool.tasks.*;

plan = buildplan();

plan("ci:madv") = ModelAdvisorTask.forEachModel();
plan("ci:web") = SimulinkWebViewTask.forEachModel();
% plan("ci:ded") = SimulinkDesignVerifierTask.forEachModel();

plan("ci:codegen") = SimulinkCoderTask.forEachModel();

plan("ci:slci") = SimulinkCodeInspectorTask.forEachModel();
plan("ci:slci").Dependencies = "ci:codegen";

% plan("ci:mil") = SimulinkTestTask.

% plan("ci:mergeTest") = MergeSimulinkTestResultsTask.
% plan("ci:mergeTest").Dependencies = "ci:mil";
% 
% plan("ci:mtMetrics") = SimulinkDashboardTask.forEachModel();
% plan("ci:mtMetrics").Dependencies = "ci:mil";
end
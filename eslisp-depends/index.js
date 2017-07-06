// Discards the first top level expression if it is (depends ...)
module.exports = function () {
  var args = Array.prototype.slice.call(arguments, 0);
  if (args.length > 0 &&
      args[0].type === "list" &&
      args[0].values.length > 0 &&
      args[0]["values"][0].type === "atom" &&
      args[0]["values"][0].value === "depends") {
    return args.slice(1);
  } else {
    return args;
  }
};

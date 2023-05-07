#!/usr/bin/env zx

const ignoreBranches = ['green', 'master'];
const grepExp = ` (${ignoreBranches.join("|")})\$`
const branches = await $`git branch -l | grep -v -E ${grepExp} | fzf --multi`

const refinedBranches = branches.stdout.split(/\n/).map(br => br.replace(/^. +/, '')).filter(br => !!br)

await Promise.all(refinedBranches.map(processBranch))
$.verbose = false;
async function processBranch(br) {
  try {
    const delResponse = await $`git branch -d ${br}`
    console.log(delResponse.toString())
  } catch(e) {
    try {
      if (e.message.includes(' is not fully merged')) {
        await $`git branch -D ${br}`;
      } else if (e.message.includes(' checked out at')) {
        const pathStr = e.message.match(/ checked out at '([^']+)'/)[1]
        await $`git worktree remove ${pathStr}`
      } {
        console.log('Unknown error', e.message)
      }
    } catch (e) {
      if (e.message.includes(' use --force to delete')) {
        const decision = await question('Force delete? (y/n)');
        if (decision === 'y') {
          try {
            await $`git worktree remove --force ${pathStr}`
          } catch (e) {
            console.log(`Failed to force delete ${pathStr}`, e.message)
          }
        }
      }
      console.log(`Failed to remove branch ${br}`, e.message);
    }
  }
}

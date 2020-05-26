# Defined in - @ line 0
function mocha_babel --description 'alias mocha_babel=npx mocha --require babel-core/register'
	env ENABLE_DEBUG_LOGGER=0 npx mocha --require babel-core/register $argv;
end

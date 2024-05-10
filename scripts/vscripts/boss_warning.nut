Msg( "-----------------------------------\n" );
Msg( "  Boss Infected Warning Initialized\n"  );
Msg( "-----------------------------------\n" );

// ---------------------------------------------
// CONSTANTS
// ---------------------------------------------
const PREFIX			= "[Boss Warn]";
const GREEN 			= "\x03";
const ORANGE 			= "\x04";
const SPACER 			= " ";
const TANKWARNING		= "A Tank is nearby!";
const WITCHWARNING		= "A Witch is nearby!";

const TANKDEAD			= "A Tank has been killed!";
const WITCHDEAD			= "A Witch has been killed!";

const TANKSNDDELAY		= 2;
const WITCHSNDDELAY		= 2;

// ---------------------------------------------
// LOCAL VARIABLES
// ---------------------------------------------
local WarnSound 		= "ui/pickup_secret01.wav";
local TankTimeDelay 	= 0;
local WitchTimeDelay 	= 0;

// Scrapped unique sound warning for Witch
// local PlayWitchSound = WitchSound[ RandomInt ( 0, WitchSound.len()-1 ) ];
/* local WitchSound =
[
	"music/witch/lost_little_witch_01a.wav",
	"music/witch/lost_little_witch_01b.wav",
	"music/witch/lost_little_witch_02a.wav",
	"music/witch/lost_little_witch_02b.wav",
	"music/witch/lost_little_witch_03a.wav",
	"music/witch/lost_little_witch_03b.wav",
	"music/witch/lost_little_witch_04a.wav",
	"music/witch/lost_little_witch_04b.wav"
]; */

// Make sure our sounds are loaded.
if ( !IsSoundPrecached( WarnSound ) )
{
	PrecacheSound( WarnSound )
}

/* foreach ( sound in WitchSound )
{
	if ( !IsSoundPrecached( sound ) )
	{
		PrecacheSound( sound )
	}
} */

// Start our Boss Warning Script.
BossWarning <-
{
    function OnGameEvent_player_spawn( params )
    {
    	if ( "userid" in params && params.userid )
		{
			// A Tank just spawned, let players know.
			local BossInfected = GetPlayerFromUserID( params.userid );
			if ( BossInfected.GetZombieType() == 8 && !Director.IsTankInPlay() )
			{
				local currentTime = Time();
				// Check if TankTimeDelay is 0
				if ( currentTime >= TankTimeDelay )
				{
					EmitAmbientSoundOn( WarnSound, 1.0, 0, RandomInt( 96, 103 ), BossInfected );
					// Add a 2 second delay to prevent sound spam.
					TankTimeDelay = currentTime + TANKSNDDELAY;
				}

				ClientPrint( null, HUD_PRINTTALK, format( GREEN + PREFIX + ORANGE + SPACER + TANKWARNING ) );
			}
		}
    }

	function OnGameEvent_witch_spawn( params )
	{
		local witchEnt = EntIndexToHScript(params.witchid)
		local currentTime = Time();

		// Check if WitchTimeDelay is 0
		if ( currentTime >= WitchTimeDelay )
		{
			EmitAmbientSoundOn( WarnSound, 1.0, 0, RandomInt( 98, 104 ), witchEnt );
			// Add a 2 second delay to prevent sound spam.
			WitchTimeDelay = currentTime + WITCHSNDDELAY;
		}

		ClientPrint( null, HUD_PRINTTALK, format( GREEN + PREFIX + ORANGE + SPACER + WITCHWARNING ) );
	}

	function OnGameEvent_player_death( params )
	{
		if ( !( "userid" in params ) )
			return;

		local victim = GetPlayerFromUserID( params[ "userid" ] );
		local zombieType = victim.GetZombieType();

		// If tank, display message
		if ( zombieType == 8 )
		{
			ClientPrint( null, HUD_PRINTTALK, format( GREEN + PREFIX + ORANGE + SPACER + TANKDEAD ) );
		}
	}

	function OnGameEvent_witch_killed( params )
	{
		if ( !( "witchid" in params ) )
			return;

		ClientPrint( null, HUD_PRINTTALK, format( GREEN + PREFIX + ORANGE + SPACER + WITCHDEAD ) );
	}
}

__CollectEventCallbacks( BossWarning, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener );
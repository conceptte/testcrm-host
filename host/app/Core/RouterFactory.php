<?php

declare(strict_types=1);

namespace App\Core;

use Nette;
use Nette\Application\Routers\RouteList;


final class RouterFactory
{
	use Nette\StaticClass;

	public static function createRouter(): RouteList
	{
		$router = new RouteList;

		/**
		 * Minicrm routes		 * 
		 * @see \Mtr\MiniCRM\Routing\RouterFactory
		 */
		$router->add(\Mtr\MiniCRM\Routing\RouterFactory::create());

		$router->addRoute('<presenter>/<action>[/<id>]', 'Home:default');

		return $router;
	}
}

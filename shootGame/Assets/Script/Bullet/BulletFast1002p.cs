using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


public class BulletFast1002p : Bullet
{

    public override void Active()
    {
        base.Active();
        timeLife = 5;
    }
}


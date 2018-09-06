using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class Singleton<T> where T : new()
{
    private static T _instance = (default(T) == null) ? Activator.CreateInstance<T>() : default(T);

    public static T Instance
    {
        get
        {
            return Singleton<T>._instance;
        }
    }
    protected Singleton()
    {
    }
}
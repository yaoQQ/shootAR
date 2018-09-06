using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class fly : MonoBehaviour {
    public float MoveSpeed = 100f;
   
    // Use this for initialization
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update ()
    {
       
            transform.Translate(Vector3.forward * Time.deltaTime * MoveSpeed);
       
    }
}

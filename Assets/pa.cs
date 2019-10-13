using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class pa : MonoBehaviour
{
    public GameObject par ;
    public float rotaionSpeed;
    public float distance;
    // Start is called before the first frame update
    // Update is called once per frame
    void Start()
    {
        Physics2D.queriesStartInColliders = false;    
    }
    void Update()
    {

        RaycastHit2D hitinfo = Physics2D.Raycast(transform.position, transform.right, distance,20);
        if (hitinfo.collider.gameObject.CompareTag("Player"))
        {
            Debug.Log("S");
        }
        else
        {
            Debug.Log("F");
        }
    }
}

import std.stdio;
import Edge;

/**
 * Author: Harry Allen
 * Date: September 20, 2014
 * 
 * Class that represents a vertex within a graph.
 */
public class Vertex
{
    private int index;      ///Vertex's index for referencing in the adjacency matrix
    private string key;     ///Vertex's key
    private Edge[] edges;   ///Array of the vertex's edges
    private bool marked;

    /**
     * Default constructor
     */
    public this()
    {
        index = -1;
        key = "";
        marked = false;
    }

    /**
     * Constructor that initializes the vertex's key with the accepted string.
     *
     * Params: key = the key for the new vertex
     */
    public this(string key)
    {
        index = -1;
        this.key = key;
        marked = false;
    }

    /**
     * Returns: true is the vertex has been marked and false otherwise.
     */
    public bool isMarked()
    {
        return marked;
    }

    /**
     * Returns: The index of the vertex
     */
    public int getIndex()
    {
        return index;
    }

    /**
     * Returns: The key of the vertex
     */
    public string getKey()
    {
        return key;
    }

    /**
     * Returns: The number of edges the vertex contains
     */
    public int getNumEdge()
    {
        return edges.length;
    }

    /**
     * Returns: The edge corresponding to index.
     *
     * Params: index = the index of te edge to be returned
     */
    public Edge getEdge(int index)
    {
        return edges[index];
    }

    /**
     * Sets the vertex's key to the given string
     *
     * Params: key = the vertex's new key
     */
    public void setKey(string key)
    {
        this.key = key;
    }

    /**
     * Sets the bool that indicates that the vertex has been marked.
     *
     * Params: marked = bool indicating whether the vertex has been marked
     */
    public void setMarked(bool marked)
    {
        this.marked = marked;
    }

    /**
     * Sets the vertex's index to the given int
     *
     * Params: i = the vertex's new index
     */
    public void setIndex(int i)
    {
        this.index = i;
    }

    /**
     * Adds an edge to the vertex.
     *
     * Params: E = new edge to add to the vertex
     */
    public void addEdge(Edge E)
    {
        edges ~= E;
    }
}